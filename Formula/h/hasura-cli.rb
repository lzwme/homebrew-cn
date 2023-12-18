require "languagenode"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https:hasura.io"
  url "https:github.comhasuragraphql-enginearchiverefstagsv2.36.0.tar.gz"
  sha256 "8626169b94530d5112e28a7b0518027f115e8f53e5baf7161474e43eee37cd60"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "760326518f084f76fd2f4285c68677d4199507b68f7b6839cf8261fe3b5c2f81"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "53f8a144df8bdfee7ec87eb4352aa6028b793eafb482a79425c263dae2c88b94"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87b26b68ab2e3cf34173848163abad6b9d944a412283d07d5b9039662cababcb"
    sha256 cellar: :any_skip_relocation, sonoma:         "4e8f0320991414d70400a8e4d578b5e2b1b7d36acee5e3bcdc96682bf9e360ca"
    sha256 cellar: :any_skip_relocation, ventura:        "0ce3263facb044fae00447e6ac3647f8510139f034ea940eb2f40c8c09d65861"
    sha256 cellar: :any_skip_relocation, monterey:       "7a75f4db98dc650d22b666937e903f2bb38f4176b021e044d8bd22ba18ae8235"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa45d59f0ed3784c29d8dcef5cef789673857693d587f5bd909c4f3016488b23"
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