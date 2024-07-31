class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https:sdk.operatorframework.io"
  url "https:github.comoperator-frameworkoperator-sdk.git",
      tag:      "v1.36.0",
      revision: "72167bf0fab99c2b533cf20f8d1c405616f15cf1"
  license "Apache-2.0"
  head "https:github.comoperator-frameworkoperator-sdk.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6560b45c2f02c01630c2ffb1ee5d5e8cd6838e8b6e33faa5f690ca2a5daaac05"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1380cc1bf7da367214e949b3003729c51ead8cdca09466d15f25793f51c630a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "575d4f450fb8803e21890d4cae30b7cdc1098355bafffc34faa17a6d9c6cecef"
    sha256 cellar: :any_skip_relocation, sonoma:         "772e51b6fc906650ad76cbb070547d775ec677d9c7a5722f486cdea200c55fa8"
    sha256 cellar: :any_skip_relocation, ventura:        "a4916ca98b2feb108d3f010d4efd86cc25d18e442b5d9d609dd0c71f38295d31"
    sha256 cellar: :any_skip_relocation, monterey:       "ebfa9014c0b7a482c3739d134e3dd08b5157c26acf6ab5a4d62f9cdcc6d03511"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4427f6c0f5a8e404b656e68d687e5d71dd3137f7e2714f174ec6e85e7d780c3"
  end

  depends_on "go"

  def install
    ENV["GOBIN"] = bin
    system "make", "install"

    generate_completions_from_executable(bin"operator-sdk", "completion")
  end

  test do
    if build.stable?
      output = shell_output("#{bin}operator-sdk version")
      assert_match "version: \"v#{version}\"", output
      assert_match stable.specs[:revision], output
    end

    output = shell_output("#{bin}operator-sdk init --domain=example.com --repo=github.comexamplememcached")
    assert_match "$ operator-sdk create api", output

    output = shell_output("#{bin}operator-sdk create api --group c --version v1 --kind M --resource --controller")
    assert_match "$ make manifests", output
  end
end