require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://ghproxy.com/https://github.com/hasura/graphql-engine/archive/v2.31.0.tar.gz"
  sha256 "adbbc0a618481605ee14febbc99cb3e991d1a933616ec3cacbcd58dc68e32253"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c55ac1532c8afe4ccd18b5e7b3346da82e06d35df8159200c99c080b971e0e49"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "188b01a5748b28f4eabc9c7f8e855fb3e4a8ba92b01afac8c55ea83bf2aee4b1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "162bf99fda95ef5079662b03b2fc4a43a49fe1064c678ba6ae4dc64b31604f12"
    sha256 cellar: :any_skip_relocation, ventura:        "4326513223c753825c238fa54f6f3a6c08e951ce102562a0ecaafc25ab8bc18f"
    sha256 cellar: :any_skip_relocation, monterey:       "6ca11458d5e4a6710c068ae0815970dc66b707542e82580313d33397c6f73e8d"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c4bf9191f7082f851542a4cfb984e2c606d26476a65762df76301bbef4b55cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f6c1b40beb422de68db15f0730dd32398cace0245c4c6bb7eb760323c5fe610"
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