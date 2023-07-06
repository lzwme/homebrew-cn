require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://ghproxy.com/https://github.com/hasura/graphql-engine/archive/v2.29.0.tar.gz"
  sha256 "df35fea844b0f927dc825b6b9c15cf4711b23339af5e81c3a382cba38c47c38b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2db8e80b6b318783112038525e8f97e77a32a05e1b308a4d08e866ceba506c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "baa5a0833ab41622aa9f02d3c0cdc59d5e08f766cec3c2079c9f67fcbe0dcad5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4cf8411afa48356c1ba0770b6fd3979164547d0a4f08f878ca640b33a94067b2"
    sha256 cellar: :any_skip_relocation, ventura:        "80d4cbaa632f08489a5bc465ca5b210165a3badc737491869ca1e0b14881f60b"
    sha256 cellar: :any_skip_relocation, monterey:       "476f8b9bf0f28cbe86ec245a259e1fba7d380f0897bc52c017e7881bc36f5092"
    sha256 cellar: :any_skip_relocation, big_sur:        "5528b57b3c91ba1e197f972de53e8826b986498935ed541558018145029706a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1c9f59a4655e2c0f019e7a92a50f05d4680e5d965ab2751a72aaf0507da4b31"
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