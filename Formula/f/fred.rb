class Fred < Formula
  desc "Fully featured FRED Command-line Interface & Python API wrapper"
  homepage "https://fred.stlouisfed.org/docs/api/fred/"
  url "https://files.pythonhosted.org/packages/dd/2c/51a14730b2091563018e948bf4f5c3600298a966c50862cd9ef98bee836c/fred-py-api-1.1.1.tar.gz"
  sha256 "e2689366a92f194f8f85db15463153a2116f241459ffc07d0bb5bbd5fb00837e"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4f4bbcf117467983ab0d2b9792a533762e0732d949a208b623dc936e2a6b0719"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5785396e15e4f499a3762b14f75e5388cb428e0548fd0303a996eac33c2c5a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9096419d5c681481ca0cd2614ac7f534ada6343e3dbe078ad31207d20ad95f37"
    sha256 cellar: :any_skip_relocation, sonoma:         "fec38be17de92195374f254437ed0567ec86f8c810e260693caf2b5a87526412"
    sha256 cellar: :any_skip_relocation, ventura:        "f2d6678b7efef07768d6b345cde9f987540e9410edecb20c5213c74c789673ad"
    sha256 cellar: :any_skip_relocation, monterey:       "0c0affe7ff545c9474e442027d344a281fc7a8aac875e6cf1b1923630d7f3414"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2402469d3fb97d6acd5f0ed30b58c12cd2f75d5028c540eca30010fd98ba72c5"
  end

  depends_on "python-setuptools" => :build
  depends_on "python-click"
  depends_on "python-requests"
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    # assert output & ensure exit code is 2
    # NOTE: this makes an API request to FRED with a purposely invalid API key
    invalid_api_key = "sqwer1234asdfasdfqwer1234asdfsdf"
    output = shell_output("#{bin}/fred --api-key #{invalid_api_key} categories get-category -i 15 2>&1", 2)
    assert_match "Bad Request.  The value for variable api_key is not registered.", output
  end
end