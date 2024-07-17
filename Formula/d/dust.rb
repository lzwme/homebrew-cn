class Dust < Formula
  desc "More intuitive version of du in rust"
  homepage "https:github.combootandydust"
  url "https:github.combootandydustarchiverefstagsv1.1.0.tar.gz"
  sha256 "2429b4ac76ad8520b99e7167dbb70c8e0088b5fad2c79f799e22b7d137d5fc33"
  license "Apache-2.0"
  head "https:github.combootandydust.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3e223877e108c9377462e0f1eef25adceb6b5e537eedf73ce6675e9be9dd87e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17ec1ee1041fbbbe4e746132abde917b53f97d262c92820d7ccdcd1aa047f858"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "448acdd9f9505cdbae62bea182f7f2fd0a89bdbd948890b6ff708e650017ddca"
    sha256 cellar: :any_skip_relocation, sonoma:         "1b6386844ac0efef56992119bdee1f879dff7de8f9dc2499a176418842481c29"
    sha256 cellar: :any_skip_relocation, ventura:        "663051593e14bbcf9dafaa36399b36c2d4d108dc4c50ed54eb3733cb941f45d5"
    sha256 cellar: :any_skip_relocation, monterey:       "9aeff7b6f3bb8e40969f7888a20699976c9b68114872eaaf09eadedfda33fa75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fbe1cce4bba384b1794ac6276204bfe44cbb020321ed005662704e8c8db6103"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "completionsdust.bash"
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