require "languagenode"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https:hasura.io"
  url "https:github.comhasuragraphql-enginearchiverefstagsv2.41.0.tar.gz"
  sha256 "4f32574148b344e4dd59c9708dc959f29a1fa050c5e7790e82523eb51ef0ae22"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "592acd9e75a0807cb0e3accd61e057735b0cd4c222827afd2190014141714d03"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c19b357ac153527222e5549e8d481a2d523de306adab8131dd15e3e88fdce7a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "832ee4544a7d3fce77de6dd9d447cee3556126d29bb6d9275a0489e0156a3f9b"
    sha256 cellar: :any_skip_relocation, sonoma:         "0d275433cfe05100bf8cf6fdd98cc72301d1f5e440ba2a0850e2874c2ea8d9e8"
    sha256 cellar: :any_skip_relocation, ventura:        "ec285264d4564ac31845238e70e110d1e66b536da5f7758844badfc23b76e1fd"
    sha256 cellar: :any_skip_relocation, monterey:       "66d93c2145bbbfd3562751f81c5a666cd21b00388e8a117e0229a983bd3db8ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9e694bb8d0fc21309bea6ac47cbd90ce7fa7fb23de3250c24fdea718f49d498"
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