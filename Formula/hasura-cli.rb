require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://ghproxy.com/https://github.com/hasura/graphql-engine/archive/v2.20.1.tar.gz"
  sha256 "b3b10ed1485cc18c5d46cb3386b442e464074d5383e9d5e9685d7e5d2c1b92fd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f55a7fe38509222a1021355a511406cd67c69583db9d181ae788736b670947c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "336f8c4e8be748739bdead6b9b20af736658a6d312d273297b2a935b1c400368"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc92c676e66c2739a4ee9ba23a58f9fb9b6e68a6f895122ce1723c2b5203873f"
    sha256 cellar: :any_skip_relocation, ventura:        "bc4dcb45c6ee433e20ed3b639122c0697b845db995547c9ee9eaedcd6c566947"
    sha256 cellar: :any_skip_relocation, monterey:       "b619bac99389f6f9bbf33a5e7ef9c21baa5c16bb165ca2b770d552564cd37e2b"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd1b1953abe9f03272a3ab46441a358249d777cd4ef06a75719500e3820d3aca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92607d153fde394d132df56fe863d7a4ce83c75bb223447cc9d61668f9738ef7"
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