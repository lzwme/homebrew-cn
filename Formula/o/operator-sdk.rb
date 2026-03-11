class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://sdk.operatorframework.io/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.42.1",
      revision: "3d5ab21480e6d262e649c8f6097b9aa0371b2b12"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d43e07be279594b8cbe180d4343c9632e6960d5bbe4e2f70f07969a4d414185e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "898afce679a1e816e9ccbb6394ebcdcea7e8bb05b00e898e70f32dd522b111fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10f8d56fe359c79f055db5052de09dfa800127fdcf54dd1c1e76848f54a7e6c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "47ae79b39d03e86df894a907fea121275f26f4aeb1d89340148adb843bd5632b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48b369e2fa1b98099fc2c57d70c87f1b411318c8b7ee608dff461a7beecb51c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2390372e158d614cb6cbbc74aefa9a7514186f7bbb8df93b7d669d5845fe1cc"
  end

  depends_on "pkgconf" => :build
  depends_on "go"
  depends_on "gpgme"
  depends_on "libassuan"
  depends_on "libgpg-error"

  def install
    ENV["GOBIN"] = bin
    system "make", "install", "CGO_ENABLED=1"

    generate_completions_from_executable(bin/"operator-sdk", shell_parameter_format: :cobra)
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