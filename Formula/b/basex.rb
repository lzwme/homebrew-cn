class Basex < Formula
  desc "Light-weight XML database and XPath/XQuery processor"
  homepage "https://basex.org"
  url "https://files.basex.org/releases/11.1/BaseX111.zip"
  version "11.1"
  sha256 "5a5ea4337c62598890a5067cfeaca8b5faecfd2be3be743400739e466b3f228d"
  license "BSD-3-Clause"

  livecheck do
    url "https://files.basex.org/releases/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "acd3742c6638ef39af472d1fca7c90fa9c9cb4eadde2fd53c865ee8f334f7704"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "acd3742c6638ef39af472d1fca7c90fa9c9cb4eadde2fd53c865ee8f334f7704"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "acd3742c6638ef39af472d1fca7c90fa9c9cb4eadde2fd53c865ee8f334f7704"
    sha256 cellar: :any_skip_relocation, sonoma:         "acd3742c6638ef39af472d1fca7c90fa9c9cb4eadde2fd53c865ee8f334f7704"
    sha256 cellar: :any_skip_relocation, ventura:        "acd3742c6638ef39af472d1fca7c90fa9c9cb4eadde2fd53c865ee8f334f7704"
    sha256 cellar: :any_skip_relocation, monterey:       "acd3742c6638ef39af472d1fca7c90fa9c9cb4eadde2fd53c865ee8f334f7704"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f4cb5dfea1cf00f66a2b84c65223f846c60eef054dd6a332470d893374276dc"
  end

  depends_on "openjdk"

  def install
    rm Dir["bin/*.bat"]
    rm_rf "repo"
    rm_rf "data"
    rm_rf "etc"

    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin", JAVA_HOME: Formula["openjdk"].opt_prefix
  end

  test do
    assert_equal "1\n2\n3\n4\n5\n6\n7\n8\n9\n10", shell_output("#{bin}/basex '1 to 10'")
  end
end