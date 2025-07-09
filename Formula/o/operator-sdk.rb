class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://sdk.operatorframework.io/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.41.0",
      revision: "0eefc52889ff3dfe4af406038709e6c5ba7398e5"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7d026eeb06e1ed23029bdfad0c80317b350d7a6eeb29052b0e935ae49265b32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58361bff9236163871831ec0c57b25b998d66528b9c4e945341748ffe5d6d91a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "47363d6d0051a24c182f4a9fd21ee3821b733276227a6921ec3fb74cc56c84fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "c093817d85e5e913a381dd97d367a20edab33d42424c2afc4f07247320f8f893"
    sha256 cellar: :any_skip_relocation, ventura:       "8fdc8c81fefbe97892f7407ac472c77d534c34f1db6160f911e9e4c3320da0be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b89b72214994b1c8777fa07bf84d499df9806afcb1d4bd1654109173465e63a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce7629a483cd7847ebebb4a973c0cc7a99c8d1bdae260492a1ef6368a1cd1642"
  end

  depends_on "pkgconf" => :build
  depends_on "go"
  depends_on "gpgme"
  depends_on "libassuan"
  depends_on "libgpg-error"

  def install
    ENV["GOBIN"] = bin
    system "make", "install", "CGO_ENABLED=1"

    generate_completions_from_executable(bin/"operator-sdk", "completion")
  end

  test do
    output = shell_output("#{bin}/operator-sdk version")
    assert_match "version: \"v#{version}\"", output
    assert_match stable.specs[:revision], output

    mkdir "brewtest" do
      system "go", "mod", "init", "brewtest"

      output = shell_output("#{bin}/operator-sdk init --domain=example.com --repo=github.com/example/memcached")
      assert_match "$ operator-sdk create api", output

      output = shell_output("#{bin}/operator-sdk create api --group c --version v1 --kind M --resource --controller")
      assert_match "$ make manifests", output
    end
  end
end