class Clive < Formula
  desc "Automates terminal operations"
  homepage "https://github.com/koki-develop/clive"
  url "https://ghfast.top/https://github.com/koki-develop/clive/archive/refs/tags/v0.12.16.tar.gz"
  sha256 "a08e5143d657a236edd1d90332b4d8c8e8a1899480b595fd8688678a86d7db84"
  license "MIT"
  head "https://github.com/koki-develop/clive.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0b29fcc772520bf0afdd5c8871fe478da12107dffadb12888f0920d05a39102"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0b29fcc772520bf0afdd5c8871fe478da12107dffadb12888f0920d05a39102"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0b29fcc772520bf0afdd5c8871fe478da12107dffadb12888f0920d05a39102"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ad2fb20130d345ff5d94fc71aff3c0ca1488e1712e3e1745cc2efe556ab78d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "431680fbf21cf45970d0c94ee94dfcc6c7c9f51bdcd6f2bf91810d70e8d540df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1150756b0727718455d75577d5c874f2428f49c2269f95395536e697adb128f6"
  end

  depends_on "go" => :build
  depends_on "ttyd"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/koki-develop/clive/cmd.version=v#{version}")
  end

  test do
    system bin/"clive", "init"
    assert_path_exists testpath/"clive.yml"

    system bin/"clive", "validate"
    assert_match version.to_s, shell_output("#{bin}/clive --version")
  end
end