class Rpl < Formula
  include Language::Python::Virtualenv

  desc "Text replacement utility"
  homepage "https://github.com/rrthomas/rpl"
  url "https://files.pythonhosted.org/packages/0b/ff/d3c4712469b296e16d6704ec4a5c5ca02479d824db0de83caee10455cb9d/rpl-1.15.4.tar.gz"
  sha256 "d89c20c3b02079db9e9a6738a0e9c0237b15623a368b6f53fa95cd866ed2630f"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f66eb46da9d1169ff8fb2a7a538500339c344bace54fd4b693a8aee56c0246e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a9d72ce02a425ec063172d48f9046483dc4aa27d8bdec98b41ee0ef91938ad3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a87fd1adc9375184f416ed2b0beab816c9cdba57375fbb84d8123e31c3df72ca"
    sha256 cellar: :any_skip_relocation, ventura:        "75f27fd3e45a0ffba6e96419d9ea186d95adec7d39356bc019f88d2a04e97487"
    sha256 cellar: :any_skip_relocation, monterey:       "1fe07b67017bf4278e9ba43885bdfc5499a13a783612150b636d40e275282d00"
    sha256 cellar: :any_skip_relocation, big_sur:        "f55773fb14b2ca077228d39d69eeefc09d42be0bcf04b35bcee581e16b04379b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34e5d531df3648e8c0b9f4a70f396a9a251dc0dbe39915ec520260d01b734eb0"
  end

  depends_on "python@3.11"

  resource "chainstream" do
    url "https://files.pythonhosted.org/packages/44/fd/ec0c4df1e2b00080826b3e2a9df81c912c8dc7dbab757b55d68af3a51dcf/chainstream-1.0.1.tar.gz"
    sha256 "df4d8fd418b112690e0e6faa4cb6706962e4b6b95ff5c133890fd32157c8d3b7"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/41/32/cdc91dcf83849c7385bf8e2a5693d87376536ed000807fa07f5eab33430d/chardet-5.1.0.tar.gz"
    sha256 "0d62712b956bc154f85fb0a266e2a3c5913c2967e00348701b32411d6def31e5"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/77/5d/98efc9cf46d60f3704cf00f8b3bd81319493639fd4367efb5d02fd29ffc1/regex-2023.5.5.tar.gz"
    sha256 "7d76a8a1fc9da08296462a18f16620ba73bcbf5909e42383b253ef34d9d5141e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test").write "I like water."

    system "#{bin}/rpl", "-v", "water", "beer", "test"
    assert_equal "I like beer.", (testpath/"test").read
  end
end