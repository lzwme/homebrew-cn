class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https:sdk.operatorframework.io"
  url "https:github.comoperator-frameworkoperator-sdk.git",
      tag:      "v1.35.0",
      revision: "e95abdbd5ccb7ca0fd586e0c6f578e491b0a025b"
  license "Apache-2.0"
  head "https:github.comoperator-frameworkoperator-sdk.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dd4a6862029fff866c9ba9bd58a52eb94830852ae8c8eab152ccb5b7d26556da"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "915de12dcbe8d95f971d8b41ccdfdfb83e780c2a16a352cf59e70ef82af413e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2415e08f7c50954c56cc803c2b22a7fb68b926e4fe43e170682da391076e84e8"
    sha256 cellar: :any_skip_relocation, sonoma:         "f55e235fc279b118c45a9cf79165b904d5d147d63ee0cce76fd921028c8a6420"
    sha256 cellar: :any_skip_relocation, ventura:        "4699d5de0debe0d57ba89a3d3bb0d55f959ed96975a965bd8fccc4816b5c94ae"
    sha256 cellar: :any_skip_relocation, monterey:       "1ea7af37f91b05e99f6bdeda3a09a0989abcda9177143ff315827fc614feefd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8102410241e3ef5ff368f5da37cf2f1a200ff891cf2ba060bf54b49c0571e68c"
  end

  # use "go" again when https:github.comoperator-frameworkoperator-sdkissues6644 is resolved and released
  depends_on "go@1.21"

  def install
    ENV["GOBIN"] = bin
    system "make", "install"

    generate_completions_from_executable(bin"operator-sdk", "completion")
  end

  test do
    ENV.prepend_path "PATH", Formula["go@1.21"].bin

    if build.stable?
      version_output = shell_output("#{bin}operator-sdk version")
      assert_match "version: \"v#{version}\"", version_output
      commit_regex = [a-f0-9]{40}
      assert_match commit_regex, version_output
    end

    mkdir "test" do
      output = shell_output("#{bin}operator-sdk init --domain=example.com --repo=github.comexamplememcached")
      assert_match "$ operator-sdk create api", output

      output = shell_output("#{bin}operator-sdk create api --group c --version v1 --kind M --resource --controller")
      assert_match "$ make manifests", output
    end
  end
end