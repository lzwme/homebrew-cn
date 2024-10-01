class ChooseRust < Formula
  desc "Human-friendly and fast alternative to cut and (sometimes) awk"
  homepage "https:github.comtheryangearychoose"
  url "https:github.comtheryangearychoosearchiverefstagsv1.3.5.tar.gz"
  sha256 "3a0a90f850026518b8ebf208ed83b7cb331b4f590dbf1ffa24b3bcc880fc392b"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "624e46f9b93a985364511ac154c7422b5381df03135f53c8e76b9e3835dbd411"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d96bd902f1354e8bebea59affcbc8c30191d74267676752fe40cafde6143b2d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6865d250d589cd9f6442c0b0f29c52fc7378b502b6b9e88b9bd67efa857443d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "d23cecc087a0c1fbd706b5c7e6f814ad02cd55a9b58c13d4bf664778772efd28"
    sha256 cellar: :any_skip_relocation, ventura:       "858c6ba1eb70feada7ff5ab29ab0fdefc686b3a1bd359eb12d3d4c4aebbb1a1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c50588ec24467aee1338680e0a329505764c0f7d90e6cd1902383784428a6d19"
  end

  depends_on "rust" => :build

  conflicts_with "choose", because: "both install a `choose` binary"
  conflicts_with "choose-gui", because: "both install a `choose` binary"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    input = "foo,  foobar,bar, baz"
    assert_equal "foobar bar", pipe_output("#{bin}choose -f ',\\s*' 1..=2", input).strip
  end
end