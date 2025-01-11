class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https:sdk.operatorframework.io"
  url "https:github.comoperator-frameworkoperator-sdk.git",
      tag:      "v1.39.0",
      revision: "d5cc16b9818671fc3e23f94037d257cb2f6d6675"
  license "Apache-2.0"
  head "https:github.comoperator-frameworkoperator-sdk.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c84bf745c1c09e7f6068b922feabec5cbb75c9666b937e3097e7458e6372dde5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "407e60e1a00d213e8639955c1c86e7ca26d6b4e841f3dbcdf4bfce7c8abbc183"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5608529be7005fe424e3e712a1aeebd4c9643d32dc36bfe73be21a6eb13773f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "348ea3b0198cefac3d921c610452cbf62a4309cfe08092339cbd237c6e28a8e0"
    sha256 cellar: :any_skip_relocation, ventura:       "ec0fd7cf57422f064242dcfaacc6332cd22da70b88d6cc75bc18cbaa7e292cd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d4dfd1a921e2bea428af8ab47bfa8c3a05e60ee8448a030806c026fbce8eff8"
  end

  depends_on "go"

  def install
    ENV["GOBIN"] = bin
    system "make", "install"

    generate_completions_from_executable(bin"operator-sdk", "completion")
  end

  test do
    output = shell_output("#{bin}operator-sdk version")
    assert_match "version: \"v#{version}\"", output
    assert_match stable.specs[:revision], output

    mkdir "brewtest" do
      system "go", "mod", "init", "brewtest"

      output = shell_output("#{bin}operator-sdk init --domain=example.com --repo=github.comexamplememcached")
      assert_match "$ operator-sdk create api", output

      output = shell_output("#{bin}operator-sdk create api --group c --version v1 --kind M --resource --controller")
      assert_match "$ make manifests", output
    end
  end
end