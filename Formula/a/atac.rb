class Atac < Formula
  desc "Simple API client (Postman-like) in your terminal"
  homepage "https:atac.julien-cpsn.com"
  url "https:github.comJulien-cpsnATACarchiverefstagsv0.18.2.tar.gz"
  sha256 "1674d189fad115b60aa2c1925aa1731cb389e52b98fb15b1c55f4e850198b556"
  license "MIT"
  head "https:github.comJulien-cpsnATAC.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2b7b4a41884bbef798cfe2833b2588f078b726579b7c8b29ddcb38e3bc19f6af"
    sha256 cellar: :any,                 arm64_sonoma:  "ae6546e8b3a8591708719a4c4bf49e9d2ec7250f7b7a82e741c9f3a0b073d137"
    sha256 cellar: :any,                 arm64_ventura: "393952e028e44fa8edeeef41b4251057143586b3d190a0ad40b5f1a63cc301a8"
    sha256 cellar: :any,                 sonoma:        "856c0ddf288e36d11ecabe69df2dc916a70348ed32374477bf923cec6595c91b"
    sha256 cellar: :any,                 ventura:       "ea2c327647fc9d16286f9c13d236c29563b07a34e0cc6f06569600fb391a442d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b95b0a0e37560cf2ad834b306ebdf25cfd59d1c4fc0b3937122675375661e0a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "oniguruma"

  def install
    ENV["RUSTONIG_DYNAMIC_LIBONIG"] = "1"
    ENV["RUSTONIG_SYSTEM_LIBONIG"] = "1"

    system "cargo", "install", *std_cargo_args

    # Completions and manpage are generated as files, not printed to stdout
    system bin"atac", "completions", "bash"
    system bin"atac", "completions", "fish"
    system bin"atac", "completions", "zsh"
    bash_completion.install "atac.bash" => "atac"
    fish_completion.install "atac.fish"
    zsh_completion.install "_atac"

    system bin"atac", "man"
    man1.install "atac.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}atac --version")

    system bin"atac", "collection", "new", "test"
    assert_match "test", shell_output("#{bin}atac collection list")

    system bin"atac", "try", "-u", "https:postman-echo.compost",
                      "-m", "POST", "--duration", "--console", "--hide-content"
  end
end