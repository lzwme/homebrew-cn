require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://ghproxy.com/https://github.com/hasura/graphql-engine/archive/v2.32.1.tar.gz"
  sha256 "e2b8a113cd34f1b3042a80ed486bedaa10ce29ecebe684b8249539ae70d2c506"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5c0079394af0a5103ed6276494b152c4479139fe9f7c431a13dc2d7b62045f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "106d94de32735c6301e5a6f203d07f4bf567cbfdddb4e29777223ea11eef682b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aac252619c390239e5b5d9ba6b0396783327f79c36c22a3a8509ad98d7fc4242"
    sha256 cellar: :any_skip_relocation, ventura:        "b49aa780f24aaddca07054cd0c32f684f200f67cddf7ae9e6666b67226a2535e"
    sha256 cellar: :any_skip_relocation, monterey:       "51fae5bfb28533d934f43d7d49c05374fe05f5e8d822079ab6ed9acb37dbaf79"
    sha256 cellar: :any_skip_relocation, big_sur:        "503ead52f0a7166ec82fad313dcbb901effb0488ea494ccf13f39da1decb96cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68fcfce9e2a37e56e47f2d3ed648fdb17a6de73d6be11be72ef760ecd1161354"
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