require "languagenode"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https:hasura.io"
  url "https:github.comhasuragraphql-enginearchiverefstagsv2.39.2.tar.gz"
  sha256 "181555b6aae6edb4f3967a4afb4a7a6080b0a78f9d9933da7e239ff2162a2996"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4df81efa0df139e0056602e08f65f8e97e115c6b15fd530b6cf5c259c5768a24"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6909545b0f9e3213c40968ae8602827df61752e2341fe92321e0364dc95c4db1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b919fee81651221cba6ac5fd335b3f149f12090183efd06bc554ad42bfc781f6"
    sha256 cellar: :any_skip_relocation, sonoma:         "299ee43941aef4317031b95886c97e7b0d00c16bdf1d5aefaf84f2333949e79c"
    sha256 cellar: :any_skip_relocation, ventura:        "22f3e77e953627e059979dcc124a27ef20c9e16f222b439fef8b54f24843f1e4"
    sha256 cellar: :any_skip_relocation, monterey:       "508be470555664d8c333274571c21dbf9beb9353d2c3f1dbe38e2e4f96714570"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8612236834bdb9330f7e1a4f84f7af0a8823e41ad545b80e3b557650abf04ac8"
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