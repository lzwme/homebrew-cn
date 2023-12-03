class Hyfetch < Formula
  desc "Fast, highly customisable system info script with LGBTQ+ pride flags"
  homepage "https://github.com/hykilpikonna/hyfetch"
  url "https://files.pythonhosted.org/packages/bb/af/0c4590b16c84073bd49b09ada0756fd9bd75b072e3ba9aec73101f0cc9f4/HyFetch-1.4.11.tar.gz"
  sha256 "9fa2c9c049ebaf0ad6d4e8e076ce90e64a4b9276946a1d2ffb6912bb1a4aa327"
  license "MIT"
  head "https://github.com/hykilpikonna/hyfetch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "66518af3ac7a67dc5cc4a67522fb15f8c57da8e91017ab08d24d11149ef86f0d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2062969f75c14c16254f4a65f8ce57aedcf3564c14c4c4c7e9bf125b833ecfc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6608c26777b27a73f7a7df8bf754fd5d5b020e1b47aeea0b1610ff8771ce8e73"
    sha256 cellar: :any_skip_relocation, sonoma:         "116960ddc9567b6ffa6edf5f10226d0faca504ec4b096cc353d77875502e51ac"
    sha256 cellar: :any_skip_relocation, ventura:        "17d4cf5e4b3ed4eb74cd48130e7845c58fec217ac8ded689e033c2faaa005402"
    sha256 cellar: :any_skip_relocation, monterey:       "6f1c82ee68b2d8b7416383bc6c5e313a7482077eadac0697c8a364868277ebb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22b1f4ba18442e4200660c0a87848441a3b82658147661a5a63c94208856c90b"
  end

  depends_on "python-setuptools"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"

  on_macos do
    depends_on "screenresolution"
  end

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    (testpath/".config/hyfetch.json").write <<-EOS
    {
      "preset": "genderfluid",
      "mode": "rgb",
      "light_dark": "dark",
      "lightness": 0.5,
      "color_align": {
        "mode": "horizontal",
        "custom_colors": [],
        "fore_back": null
      },
      "backend": "neofetch",
      "distro": null,
      "pride_month_shown": [],
      "pride_month_disable": false
    }
    EOS
    system "#{bin}/neowofetch", "--config", "none", "--color_blocks", "off",
                              "--disable", "wm", "de", "term", "gpu"
    system "#{bin}/hyfetch", "-C", testpath/"hyfetch.json",
                             "--args=\"--config none --color_blocks off --disable wm de term gpu\""
  end
end