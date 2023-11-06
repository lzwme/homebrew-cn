class Mackup < Formula
  include Language::Python::Virtualenv

  desc "Keep your Mac's application settings in sync"
  homepage "https://github.com/lra/mackup"
  url "https://files.pythonhosted.org/packages/89/ed/91b0a13329ce4e5ea4fcbbcffb89ad573adc83dfb8af87154aa1ab0dff0e/mackup-0.8.39.tar.gz"
  sha256 "a769d49adf73457e45bc7232aacf9da0fa7f9ec1de240ee3ac5a9613af003687"
  license "GPL-3.0-or-later"
  head "https://github.com/lra/mackup.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9347905bc0ae17d3d51df785ca6bd45145ff02898d2710fe06a3788f6e4009ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "867e96bb7aa178db0a1fd3a6844cd9d6acfd9ad470ec99bd95b3a37521ab1ae2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc91ac18a0ca0d292b9fc2e622d992cc3eac3c4b0fb9cda3537ad4708ba3a2f2"
    sha256 cellar: :any_skip_relocation, sonoma:         "dfa129ab5fb7c18db970dccb2a26b60d7ea241af5ea7da6057118422a7c6b34e"
    sha256 cellar: :any_skip_relocation, ventura:        "1f3d64c2bbfd4d7ea921c43a8156fb41ae4f61e74b2abbdb023c2a63343c12e6"
    sha256 cellar: :any_skip_relocation, monterey:       "dc34cd14c91d75d6a40474134849670426d104799151c4912f13c044fa82a66a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1dd4397391d603c29201e7d2a3293083a43de69f5dd4736a70c538b4adc2f6b"
  end

  depends_on "python@3.12"
  depends_on "six"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/mackup", "--help"
  end
end