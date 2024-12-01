# Go Install Script

This script installs Go packages listed in a file. Each line of the `.goinstall` file should contain a Go package in the format `github.com/username/repo@version`.

**This script does not install Go on your system.** We reccomend using [`proto`](https://moonrepo.dev/proto) to install and manage tools like Go.

## Usage

### Default Usage

Running the `install_go_packages.sh` script will install the packages specified in the `.goinstall` file in the current directory:

```bash
./install_go_packages.sh
```

### Custom `.goinstall` File

You can also specify a custom file by using the -f flag:

```bash
./install_go_packages.sh -f /path/to/custom_file.goinstall
```

### Running Remotely

This script can be run remotely using `curl`:

```bash
curl -sSfL https://raw.githubusercontent.com/epicexecute/go-install-script/main/install_go_packages.sh | sh -s -- -f .goinstall
```

## The `.goinstall` File

We reccomend creating a `.goinstall` file in your project's root. It should contain a list of Go packages or comments in the following format:

```text
# comment
github.com/username/repo@version
```

Here's an example file that installs common Go tools and `protoc` plugins:

```text
# go tools
github.com/segmentio/golines@latest
mvdan.cc/gofumpt@latest

# protoc plugins
github.com/sudorandom/protoc-gen-connect-openapi@main
github.com/voi-oss/protoc-gen-event/cmd/protoc-gen-event@latest
```

## Using with `proto` Version Manager

This script expects Go to be installed in your `$PATH` and it uses `go install` to install Go packages in the default `$GOBIN` location (`~/go/bin`).

If you used `proto` to install Go with default settings, it sets the default `$GOBIN` location in your shell. It does not, however, add that location to your `$PATH` [(source)](https://moonrepo.dev/blog/proto-v0.5#install-global-binaries).

You must manually add your `$GOBIN` directory to your shell's `$PATH`. **If you do not do this , packages installed by this script (or any other invocations of `go install`) will not be discoverable by your shell.**

### Using Devcontainer

Add the following to your devcontainer's `Dockerfile`:

```docker
RUN echo "\n # append default GOBIN to PATH \nexport PATH=\"\$HOME/go/bin:\$PATH;\"" >> ~/.zshrc
```

Remember to rebuild your devcontainer after saving the `Dockerfile`.

### Using `zsh` Shell Profile

Run the following to append the default `$GOBIN` to the end of your `$PATH` within your `.zshrc` file, then reload your shell profile:

```bash
echo "\n # append default GOBIN to PATH \nexport PATH=\"\$HOME/go/bin:\$PATH;\"" >> ~/.zshrc
source ~/.zshrc
```

## Why Create This?

We needed to predictably install the same Go packages (i.e. `golines`, `gofumpt`, etc.) and `protoc` plugins in our Devcontainer and CI/CD environments. We also needed an easy way to re-install those packages when they changed for the project. Rather than manually keeping track of everything in other configs and README files, we chose to create a config file (`.goinstall`) and a script (`install_go_packages.sh`) to automate the process.

In our devcontainers, we call the script remotely in a `postStartCommand` to install the latest Go packages for the project every time our devcontainer starts:

```bash
curl -sSfL https://raw.githubusercontent.com/epicexecute/go-install-script/main/install_go_packages.sh | sh -s -- -f .goinstall
```

## Requirements

- Go 1.17+ should be installed on your system.
- The `go` binary must be available in your shell `$PATH`.
- The `$GOBIN` variable should be set so packages are installed in a known, repeatable location.

## License

This script is released under the MIT License. See LICENSE for more details.
