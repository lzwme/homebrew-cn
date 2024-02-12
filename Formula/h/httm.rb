class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFSbtrfs"
  homepage "https:github.comkimono-koanshttm"
  url "https:github.comkimono-koanshttmarchiverefstags0.36.1.tar.gz"
  sha256 "acccb92f509061ef599c848f949318e517be16b5a14b453bce6807d70dadf40c"
  license "MPL-2.0"
  head "https:github.comkimono-koanshttm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "77593d9d18b189e04e2ef01698e28363c61e9cedacbab418c112f381997c3a10"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "034cace42b554beae0400651be1ff87eed372619027ca1c02ceb440f306f2cb7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "903f4d8ebd7081cfb14bf1c28d9702c9ea7876ba45b46c3d7f34ea68788d62f3"
    sha256 cellar: :any_skip_relocation, sonoma:         "970c64cba6f151905b5a57859e7775a08a0ae29bfe700b90fff057ba6571b8d7"
    sha256 cellar: :any_skip_relocation, ventura:        "bf77580c79b6c0cc4206318993a11c25b361273c13ebebcf33cf6b078c6633cf"
    sha256 cellar: :any_skip_relocation, monterey:       "e88b0eb909724a87a657a577a8276dbb8bef9a9cfc84cddc09d19b77368cd6c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b068754345243762fde6b7695fb6e3e36daea20ab7aad79c993e8be65c8e221"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "acl"
  end

  def install
    system "cargo", "install", "--features", "xattrs,acls", *std_cargo_args
    man1.install "httm.1"

    bin.install "scriptsounce.bash" => "ounce"
    bin.install "scriptsbowie.bash" => "bowie"
    bin.install "scriptsnicotine.bash" => "nicotine"
    bin.install "scriptsequine.bash" => "equine"
  end

  test do
    touch testpath"foo"
    assert_equal "Error: httm could not find any valid datasets on the system.",
      shell_output("#{bin}httm #{testpath}foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}httm --version").strip
  end
end