class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https:github.comalexpasmantiertelevision"
  url "https:github.comalexpasmantiertelevisionarchiverefstags0.8.7.tar.gz"
  sha256 "7f7a78651297ac311c88c282833f35bef677fd50a2bbe1bff043e0583b57535e"
  license "MIT"
  head "https:github.comalexpasmantiertelevision.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "144d7a3024afded808d40a77a30a5c1a6c0567eeebd45d8ac846d034f1087e28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04731201c331fcd6bdca3282ca2b4eb4fbf176d4395b4fd39558929b3ab1a2fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a33753f022db82c2f9cfbaf481787660262278cb61c1484ac5e45122083f8211"
    sha256 cellar: :any_skip_relocation, sonoma:        "5126edccb631b3398675f91d12d29a1e5208584fb8f8abe09725eea6a8af8824"
    sha256 cellar: :any_skip_relocation, ventura:       "a4da59970ec94315636a3376547e377538caf048402d54c8c5145521eb67bc28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d42d28273c2a2383340326bf21b3a93fcb4037448fd34155fd49c28f06dcd8e"
  end

  depends_on "rust" => :build

  conflicts_with "tidy-viewer", because: "both install `tv` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}tv -V")

    output = shell_output("#{bin}tv list-channels")
    assert_match "Builtin channels", output
  end
end