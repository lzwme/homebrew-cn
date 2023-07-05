require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://ghproxy.com/https://github.com/hasura/graphql-engine/archive/v2.28.2.tar.gz"
  sha256 "90065113653a681fa8fce155629777d01cd5e216338be651aaebdb9d96514399"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad65c390e18ac961359fe5c435163063019cec65681159145a4fc02357063aee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3eb0c3174b2394a589995c06540c95343805a48d432582551d31d5935f3ccac6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "272bf47ae69a4522c15aee6de52a3918f25f9ef244766e7003f33799a100c240"
    sha256 cellar: :any_skip_relocation, ventura:        "330fb00d7211664e58c6c1b90954c910777ca3961f5654e1cccb67e31a5cf32c"
    sha256 cellar: :any_skip_relocation, monterey:       "72c7a186088a88fa68858001a88a5ba29faed8c18579d0f0e165745e729a6189"
    sha256 cellar: :any_skip_relocation, big_sur:        "6972d980458a000d597311398d3cc8b6e1f86f4d8e6102864798f087d29ad13c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d6dc656823ef09fe74dcaedf16c0c50ecec6835281881c01784aa6d3545242d"
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