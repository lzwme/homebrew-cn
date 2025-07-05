class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://sdk.operatorframework.io/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.40.0",
      revision: "c975e3a03ef8e3d589806b679638f55036b56212"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "670e344565d12af5238db4ae8d7fdcbcc0778ab2c5094b5a05db449afbeca6f8"
    sha256 cellar: :any,                 arm64_sonoma:  "ba14738fa09f79d74baa4156d63677d2becfc9bdd8aa531a5f1bbddc581b968d"
    sha256 cellar: :any,                 arm64_ventura: "3ecdf463337ab7d9368f5cbfa20282431153fac79c38fb9ee7664802f71733d7"
    sha256 cellar: :any,                 sonoma:        "3d6b4ec986d141778a433631e3cbbb31c80b2b9dccfc8d90aaa2ca99011910f1"
    sha256 cellar: :any,                 ventura:       "11f5be03a8e4f5c8418ad33e7aa77f8637ee793aee3cd8876ac5c8ae706a6c99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e72eac38d166ef1ec6c9f67dc320cf76c0b25646285ca718a9cbdf2ee81ac354"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73d38750fd4ce30974342cfd559332e188dbb7d4e5d86c999bac02987aaaef59"
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