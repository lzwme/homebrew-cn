class Dust < Formula
  desc "More intuitive version of du in rust"
  homepage "https:github.combootandydust"
  url "https:github.combootandydustarchiverefstagsv1.1.2.tar.gz"
  sha256 "31da99483ee6110d43ed5e7c56a59f40f33b389e45d09d91fca022b42d442040"
  license "Apache-2.0"
  head "https:github.combootandydust.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3798757adf5b998362bb0183337c4085b5edaecb26719bdec849656aafd83557"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0946971982006b04529fa7330d142ca9b5a2baee707f736962675676504428e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9da5e05e0e6501858e20f592b05b311b490522d1614c3c96ab6a24de7c4156d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "be3492cf0abbfec5e6c55fe6a014d6c94dc0d586dad709a74b300ec7b251d489"
    sha256 cellar: :any_skip_relocation, ventura:       "239dfd5587cda64044f8c7e42665111e868856ae3451e32826befc1e57da561c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2863f676bd927b26075497e3adb25b053e7b1f34d526b136fbdae60ad41801c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9077948ddeefd028ed4db202363c5c00b8151a3ab8ff62974b2717114f6b5ff6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "completionsdust.bash" => "dust"
    fish_completion.install "completionsdust.fish"
    zsh_completion.install "completions_dust"

    man1.install "man-pagedust.1"
  end

  test do
    # failed with Linux CI run, but works with local run
    # https:github.comHomebrewhomebrew-corepull121789#issuecomment-1407749790
    if OS.linux?
      system bin"dust", "-n", "1"
    else
      assert_match(\d+.+?\., shell_output("#{bin}dust -n 1"))
    end
  end
end