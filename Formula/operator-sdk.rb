class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://sdk.operatorframework.io/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.28.1",
      revision: "b05f6a56a176a98b7d92c4d4b36076967e0d77f7"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3dcaf9488bc4fda11eb2d0a23baa6a3a8c4cdc53a4b200474892391911df328f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "952ad2ea07a36a02e25e35917b835eb625917c495043aa5e335b82539e7a3712"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e984f0919163bd8dfe16fd9adbc013dba463bc39346237a43f2d3c0bca739f2d"
    sha256 cellar: :any_skip_relocation, ventura:        "e05941b4ffe4dde466f9eedcdbbec10d05a4a7e842b48df09d87531f91294b07"
    sha256 cellar: :any_skip_relocation, monterey:       "fd0e2921287f137ab52ad43ae027473ff32194140d8b24f9d3a84f1af99d833b"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa886bb884ce299224f5d872e5a6b030c747022aaaa3b95ee55a087d0abcbfbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74939de3a7a76fdba2f7fabeacce332bba608af94746f1ee4d50ec8363b0b599"
  end

  depends_on "go"

  def install
    ENV["GOBIN"] = bin
    system "make", "install"

    generate_completions_from_executable(bin/"operator-sdk", "completion")
  end

  test do
    if build.stable?
      version_output = shell_output("#{bin}/operator-sdk version")
      assert_match "version: \"v#{version}\"", version_output
      commit_regex = /[a-f0-9]{40}/
      assert_match commit_regex, version_output
    end

    mkdir "test" do
      output = shell_output("#{bin}/operator-sdk init --domain=example.com --repo=github.com/example/memcached")
      assert_match "$ operator-sdk create api", output

      output = shell_output("#{bin}/operator-sdk create api --group c --version v1 --kind M --resource --controller")
      assert_match "$ make manifests", output
    end
  end
end