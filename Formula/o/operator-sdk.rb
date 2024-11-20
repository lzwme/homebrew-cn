class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https:sdk.operatorframework.io"
  url "https:github.comoperator-frameworkoperator-sdk.git",
      tag:      "v1.38.0",
      revision: "0735b20c84e5c33cda4ed87daa3c21dcdc01bb79"
  license "Apache-2.0"
  head "https:github.comoperator-frameworkoperator-sdk.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c4b04e80ed196e7938f476f1e7c60ea0bf7b635ae998c2343a443786fb94a73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4b7c0797185ad1c42483a80094c8b7511b000d2b83136c713c5c97380a7fa26"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d24d19cea8d61af17dc352b596ea1ce6c5b02b76beb099138f87759d973de2dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "be250ca513dd5b0ce9c3f846305f2bdfc6c5d9940189f6a6d44df1617f727689"
    sha256 cellar: :any_skip_relocation, ventura:       "24a48c8511256c7c31d17a63d372e0075754a53a1aadc1b148196cae67996225"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5f724fb8c01971fce2322a519ac6b1a9a2d8092c95ceccaa967e7ae54d1fc83"
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