class Jd < Formula
  desc "JSON diff and patch"
  homepage "https:github.comjosephburnettjd"
  url "https:github.comjosephburnettjdarchiverefstagsv1.8.0.tar.gz"
  sha256 "f278d5638b78f11a019d24f8efdb94cfbf49713e2e59633882d8569e265c1c89"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db69ad7ce37d3f06a89b42cfb13825e4989ec52e197f0a8f34248d2ecbe5a37a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e57a48dc10527b6a9c001f2d6b6546944d16833b810d9d4086385f4d4bc271d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0f86b60834e596514dce39a21cc76f5124e59bcdf76c01d0fa460277fe73fcc"
    sha256 cellar: :any_skip_relocation, sonoma:         "0770e5b6304a06bf24ea6a4f4e9fd7203e97cb61dd112a7377420cb674799704"
    sha256 cellar: :any_skip_relocation, ventura:        "cc43d5e2493b74d2a91f326194102d6e8f9d42e6be528c053d7a0bb2a1c90cde"
    sha256 cellar: :any_skip_relocation, monterey:       "40033816854c930c5ba1a1d03cd014fbf2a57b271793119656c54dc0d3b34f7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3b6cac5f8429f6843697a56a6e81b954c087acc87d2978c35c1e7769184258e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath"a.json").write('{"foo":"bar"}')
    (testpath"b.json").write('{"foo":"baz"}')
    (testpath"c.json").write('{"foo":"baz"}')
    expected = <<~EOF
      @ ["foo"]
      - "bar"
      + "baz"
    EOF
    output = shell_output("#{bin}jd a.json b.json", 1)
    assert_equal output, expected
    assert_empty shell_output("#{bin}jd b.json c.json")
  end
end