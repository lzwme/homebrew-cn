class Faker < Formula
  include Language::Python::Virtualenv

  desc "Python-based fake data generator"
  homepage "https://faker.readthedocs.io"
  url "https://ghfast.top/https://github.com/joke2k/faker/archive/refs/tags/v40.36.0.tar.gz"
  sha256 "528514892b756bf0f28cfc83794fc29f13dc6293a5a2a4933cc89270b9831e78"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "be113de7fcb716daaab705eff1e1099e198793d38af6f8ef0123e834661a477b"
  end

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "{'ssn': '150-19-7120', 'name': 'Christian Blake'}",
                 shell_output("#{bin}/faker --seed 12345 profile ssn,name")
  end
end