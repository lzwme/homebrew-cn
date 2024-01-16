require "languagenode"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https:hasura.io"
  url "https:github.comhasuragraphql-enginearchiverefstagsv2.36.2.tar.gz"
  sha256 "6e7752501e25917a6c83a88e59dbbc270eccaed3cacb091d32bb1c50d5df2169"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7209f1129b3ab9f1d8a9a6beb5c644e8109abfd41d5fc4b3cdc527ee61f83d6d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "540de5ea0d1ea3e9e27d8009c32f9d810218ef27a942b5c5eacd1f6022d2ea00"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a945c7afb228d097cc9f48424955c36aa7ad9487009721342941bbd1e8fdea5e"
    sha256 cellar: :any_skip_relocation, sonoma:         "b62618f6860a47262d71095f70be6c3c717058929e0ff5b948fb6aeb6f8a03a8"
    sha256 cellar: :any_skip_relocation, ventura:        "6ee1c032ed20bb9e0058d207c0d961aaa317506a96b5622ac88f837d5e9fb629"
    sha256 cellar: :any_skip_relocation, monterey:       "4a0187306c9fd90a62b13fb0905d85ec4be100c6d61940f9e717f6ee33936c3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f34b62a87499787870e3964092c86fdeb9639678830509a318780323243bbf0"
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