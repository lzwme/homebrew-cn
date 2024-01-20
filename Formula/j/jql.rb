class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https:github.comyamafaktoryjql"
  url "https:github.comyamafaktoryjqlarchiverefstagsjql-v7.1.3.tar.gz"
  sha256 "994e05190e9e215a6f5b5e78ca76ae8695e904e7619b6d15ad9c1417fbb82467"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comyamafaktoryjql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "564bb7c6e1cb34e18630e45c09fa1f7e2aa82416ea3d6aea29821276e9622603"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "774d9b1a8b9de591ccb1cca3a05deb9f646c56d341fc1c0a71d15c518452bb12"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89b5c17f699f836cee010dab3f8b7bcaf97509f2abc2dc571471c7de4e8748e0"
    sha256 cellar: :any_skip_relocation, sonoma:         "50a75fb002036710c23c8d48d826bbc0d5b89afc513dd9fc30c00e1370120280"
    sha256 cellar: :any_skip_relocation, ventura:        "611fb57b54e34dd75f4f29062c0bb46aaa85b55cc8ca6ba919555498811b2d3b"
    sha256 cellar: :any_skip_relocation, monterey:       "9c27dfc1dddc22adb889d3781b3e8b4c3a1cfab0c1f7523f92ce859cc09bbdba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ddf9d01ca2a954c22afbcc418b3380b4ed94a9b1e7ba7b67d7aeb78cedf3108"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratesjql")
  end

  test do
    (testpath"example.json").write <<~EOS
      {
        "cats": [{ "first": "Pixie" }, { "second": "Kitkat" }, { "third": "Misty" }]
      }
    EOS
    output = shell_output("#{bin}jql --inline --raw-string '\"cats\" [2:1] [0]' example.json")
    assert_equal '{"third":"Misty"}', output.chomp
  end
end