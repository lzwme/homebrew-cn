require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://ghproxy.com/https://github.com/hasura/graphql-engine/archive/v2.25.1.tar.gz"
  sha256 "d2271ac7336f5c99a1624049877aa431a963d00550681f7e4550e9f4a7e66e38"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e6b6a3e8e632fff2bf8d6fa863dd9e1c5cace04475c05d447c65144f932e311b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc2547b8a645b039f855cfead869d1de59a7d005c060c320ec9af4279b497679"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ab0cae84f97613d68434c9118751854c1358fbb9451a8a92b43ae6e977db054"
    sha256 cellar: :any_skip_relocation, ventura:        "66e47d5f173e582edb24e61498afce53731b6752065e4506f092835f102010bf"
    sha256 cellar: :any_skip_relocation, monterey:       "1ede8d057590cf6c6af262e61d955b29a2ee5a5140f491c0d989a60612a97bec"
    sha256 cellar: :any_skip_relocation, big_sur:        "221415a5cce997bbc1b4a6593038d51e25e3c160ab1e5da66a81bf63f30f3327"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2dd715cff60b3a2de81213a8d04aaf6a099eaf10d59f9e6f4ffe5915d8bddb4b"
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