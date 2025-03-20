class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https:infisical.comdocsclioverview"
  url "https:github.comInfisicalinfisicalarchiverefstagsinfisical-cliv0.36.19.tar.gz"
  sha256 "623de69ef88b0879171443db987e467308ee69b828eea01337b3778a7c561bd8"
  license "MIT"
  head "https:github.comInfisicalinfisical.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^infisical-cliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d8150a8981976759821235de1d5da8e72a1e479ec261a06be62877f00297a67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d8150a8981976759821235de1d5da8e72a1e479ec261a06be62877f00297a67"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8d8150a8981976759821235de1d5da8e72a1e479ec261a06be62877f00297a67"
    sha256 cellar: :any_skip_relocation, sonoma:        "412a84ccad678cd31a76f95fa4a23fdd54256726186b3c0b0625e26db459b372"
    sha256 cellar: :any_skip_relocation, ventura:       "412a84ccad678cd31a76f95fa4a23fdd54256726186b3c0b0625e26db459b372"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2eda3b4f55984adb5e667105fa9b7669adec5112ce5a5abce6dc76660627e7e"
  end

  depends_on "go" => :build

  def install
    cd "cli" do
      ldflags = %W[
        -s -w
        -X github.comInfisicalinfisical-mergepackagesutil.CLI_VERSION=#{version}
      ]
      system "go", "build", *std_go_args(ldflags:)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}infisical --version")

    output = shell_output("#{bin}infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}infisical init 2>&1", 1)
    assert_match "You must be logged in to run this command.", output
  end
end