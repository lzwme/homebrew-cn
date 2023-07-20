require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://ghproxy.com/https://github.com/hasura/graphql-engine/archive/v2.30.0.tar.gz"
  sha256 "f1afc981e235f5ee2b02785f13a572b54d8a0f7c6ee295f1b2e5a700ccdeb88d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80abd1bbb780fbfac0922eb1628889822b08d8d85182627b0f22dc9420709875"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ca2aa6f4c25c426fd1d57af013d4eedc3ae949772a125545b00b2d613e2bba5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c4dafe64116ec979e7d3164f93c18f806890f45f5eb2e46b5b4242f2ed5bb104"
    sha256 cellar: :any_skip_relocation, ventura:        "f34e532a6547b7d3033163a7cc24dc780a778a4b7d8be97ec1f863aed1314677"
    sha256 cellar: :any_skip_relocation, monterey:       "589860b12fb5bbde3184193ec475a9cf3ee27ed4e30f62fcb0e8302b235a6b77"
    sha256 cellar: :any_skip_relocation, big_sur:        "a590a23fa5fc68e92ded42b6bcfc416bd9aaa13352cf9a356e98d14eb7e28800"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b19dd4e0d20a2e92e85f9ec0ac46d45ef916ed14caffb3f369b1b12f31b0d46"
  end

  depends_on "go" => :build
  depends_on "node@18" => :build

  def install
    Language::Node.setup_npm_environment

    ldflags = %W[
      -s -w
      -X github.com/hasura/graphql-engine/cli/v2/version.BuildVersion=#{version}
      -X github.com/hasura/graphql-engine/cli/v2/plugins.IndexBranchRef=master
    ]

    # Based on `make build-cli-ext`, but only build a single host-specific binary
    cd "cli-ext" do
      # TODO: Remove `npm update pkg` when https://github.com/hasura/graphql-engine/issues/9440 is resolved.
      system "npm", "update", "pkg"
      system "npm", "install", *Language::Node.local_npm_install_args
      system "npm", "run", "prebuild"
      system "./node_modules/.bin/pkg", "./build/command.js", "--output", "./bin/cli-ext-hasura", "-t", "host"
    end

    cd "cli" do
      arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
      os = OS.kernel_name.downcase

      cp "../cli-ext/bin/cli-ext-hasura", "./internal/cliext/static-bin/#{os}/#{arch}/cli-ext"
      system "go", "build", *std_go_args(output: bin/"hasura", ldflags: ldflags), "./cmd/hasura/"

      generate_completions_from_executable(bin/"hasura", "completion", base_name: "hasura", shells: [:bash, :zsh])
    end
  end

  test do
    system bin/"hasura", "init", "testdir"
    assert_predicate testpath/"testdir/config.yaml", :exist?
  end
end