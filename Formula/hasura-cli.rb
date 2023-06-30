require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://ghproxy.com/https://github.com/hasura/graphql-engine/archive/v2.28.1.tar.gz"
  sha256 "e22a1102239527a3c3de5446b12f3359e93c948d8c53b537dc37a2915bc2880f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93886096ece9d87328dffd7bba301f0740e5a31812f1312eb024686ef3ab3ca8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2ab786a94b32c2dd277c4ba9902945e694e38189c4c5bf86173f044d25f114c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3ca36cad87856335367b91918ac92405ba26cca27303c70a3db1bb346f032fcd"
    sha256 cellar: :any_skip_relocation, ventura:        "6c3c18ce8f0f85bd948f632bf9838b0fde3849e3fbb8e6e57e2d360563e3848b"
    sha256 cellar: :any_skip_relocation, monterey:       "3bdf1d8e81db3d57fc3433c345ce4b5af749ba3fcdbbbad5e80ce345d338e50e"
    sha256 cellar: :any_skip_relocation, big_sur:        "d2b3f553d8274d19b487053d7a2833360e76a0fbbaa85ef785164e8689e08fa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee3d891376cb16bd1e120ef3b2e47c5dc39c0a8f21d0756a33926ac5d16e0933"
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