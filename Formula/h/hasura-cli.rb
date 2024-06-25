require "languagenode"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https:hasura.io"
  url "https:github.comhasuragraphql-enginearchiverefstagsv2.40.2.tar.gz"
  sha256 "d99e9d764827897e3892d410c1bf9656df7bd148675fc9973ed35c7452d12d31"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "af4c77951078782fd2f88bd6f068ee496fab96029bad245a0f9620067eafdf83"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad640a34bccd776393222b9328068257d9c8c8c2be14b0df6d7f5492b6ef9f8a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a505b4da7f5b939da9784e74d17269ef4a17615aaba7773c3f45c99b5abe46b5"
    sha256 cellar: :any_skip_relocation, sonoma:         "b6d9ecd7f653cd6cf554775ad7522f27033779f4731a3c1d66c251d490692002"
    sha256 cellar: :any_skip_relocation, ventura:        "1883d1fe0e80e12a53535b2f840e97500d110c58dabf6d63cf99a2e57f8b7a9c"
    sha256 cellar: :any_skip_relocation, monterey:       "6ff54d2a140777c36f7b293e3995737d017b71282e87210da708e271dc9625c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16b26a068672ae356a7a21f7f4a12efaaee3b8bbf25984ace5cd9669dcb1659d"
  end

  depends_on "go" => :build
  depends_on "node@18" => :build

  def install
    Language::Node.setup_npm_environment

    ldflags = %W[
      -s -w
      -X github.comhasuragraphql-enginecliv2version.BuildVersion=#{version}
      -X github.comhasuragraphql-enginecliv2plugins.IndexBranchRef=master
    ]

    # Based on `make build-cli-ext`, but only build a single host-specific binary
    cd "cli-ext" do
      # TODO: Remove `npm update pkg` when https:github.comhasuragraphql-engineissues9440 is resolved.
      system "npm", "update", "pkg"
      system "npm", "install", *Language::Node.local_npm_install_args
      system "npm", "run", "prebuild"
      system ".node_modules.binpkg", ".buildcommand.js", "--output", ".bincli-ext-hasura", "-t", "host"
    end

    cd "cli" do
      arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
      os = OS.kernel_name.downcase

      cp "..cli-extbincli-ext-hasura", ".internalcliextstatic-bin#{os}#{arch}cli-ext"
      system "go", "build", *std_go_args(output: bin"hasura", ldflags:), ".cmdhasura"

      generate_completions_from_executable(bin"hasura", "completion", base_name: "hasura", shells: [:bash, :zsh])
    end
  end

  test do
    system bin"hasura", "init", "testdir"
    assert_predicate testpath"testdirconfig.yaml", :exist?
  end
end