require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://ghproxy.com/https://github.com/hasura/graphql-engine/archive/refs/tags/v2.35.1.tar.gz"
  sha256 "22dac95660b664c3790c4b53b1a262e214faacce1d793204fc4717451e2c55f0"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "46106d2ec92777f330c27a7dbea9fc1d9c6ea90376b9bac714ede32c3afeca01"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3223f40ca7528ab6e7fc66573a20782cf7f45066efe9763a1bdc1c0bae1754d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce2db8d0f7364f6b977b341442ea8885a2d10f5d3a4f12aeecfc0064f6a645a7"
    sha256 cellar: :any_skip_relocation, sonoma:         "bc9ca72ca0d2840f60fc8543abb929dd2d17ea75276e3680563f547021fe5ad3"
    sha256 cellar: :any_skip_relocation, ventura:        "d62b46fb64dba16fe0e81eb26b9c04528871b1e675bdaab5cdbc7e8e29b78f6d"
    sha256 cellar: :any_skip_relocation, monterey:       "4896fb96f9e617e7cdb21a9d66721961b8cdc21e674323c3acab169dc7347676"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85c5573571faf5ed7a0b330889b0cda9866c970897586c8121cec68e5e5aa78a"
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