require "languagenode"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https:hasura.io"
  url "https:github.comhasuragraphql-enginearchiverefstagsv2.36.3.tar.gz"
  sha256 "5c8b95747a014824a9ce2901119e9502b17458b0aee02417dea4855bb6c33438"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6bd2e7f1a0033c2329edbc56b07943767312506b5003d0482b3ab1cf62e8e831"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0aede514680762ce23c1ff61841cff73667ed79de9ee748361c9340da12a434"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1953ee07f0cfaf7375fc488dc21abe8b9e8f3970d4a4af07066e3c67a2bb2879"
    sha256 cellar: :any_skip_relocation, sonoma:         "847680b8bb904e8c0b7a0e1cfe6e49c1e2d6df67c63d0287dba4bcf337006eb7"
    sha256 cellar: :any_skip_relocation, ventura:        "dd6dfaa4961d0fe89b125cdfc25398b9b69f91bbd2cf0db260a2292d68684168"
    sha256 cellar: :any_skip_relocation, monterey:       "b6e747a5173652258debba3525de451588fbf7041b74ced1b966621b1f7fb27a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f19608245e27c0641d314466f8a38f49477230943d7bf056d0c58030b4a0b12"
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
      system "go", "build", *std_go_args(output: bin"hasura", ldflags: ldflags), ".cmdhasura"

      generate_completions_from_executable(bin"hasura", "completion", base_name: "hasura", shells: [:bash, :zsh])
    end
  end

  test do
    system bin"hasura", "init", "testdir"
    assert_predicate testpath"testdirconfig.yaml", :exist?
  end
end