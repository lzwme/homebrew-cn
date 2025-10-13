class Hyfetch < Formula
  include Language::Python::Virtualenv

  desc "Fast, highly customisable system info script with LGBTQ+ pride flags"
  homepage "https://github.com/hykilpikonna/hyfetch"
  url "https://files.pythonhosted.org/packages/35/f2/8b24d32c63110d3ba7e5e4c88827827cb05eb4e3d14c6652304c546b0e71/hyfetch-2.0.2.tar.gz"
  sha256 "d11eed4b6082095a9e41272fb846e9ed029b172847c9d30e8646eabee9da2b12"
  license "MIT"
  head "https://github.com/hykilpikonna/hyfetch.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f82f4e50eb3c62eb0ab5cc82fc1c8e58e63afc463008d98a3ae25b801fbd8d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "725e98544ce86f0c7a2d18029459ce0276bcdd40286cb212b5134c967f49f01a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92bc28f88c2baa32f43123fb421d2c29ed17c713cd6f7d9e594d65baabbfdcdc"
    sha256 cellar: :any_skip_relocation, sonoma:        "2bdf0d04b0cafe2b8cdfa67cc46e53218644a93b9810fbaca8052f3000dadcbf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aba0789b2ddad86dd18bee99a78966358616a168a0501a915f644547efa9a16f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ec37150375367a6669ce33826ecde93af7e81180b46016a389057f3345aa87a"
  end

  depends_on "rust" => :build
  depends_on "python@3.14"

  def install
    # Install to `buildpath` first or else `virtualenv_install_with_resources` will overwrite it.
    system "cargo", "install", *std_cargo_args(path: "crates/hyfetch", root: buildpath)
    venv = virtualenv_install_with_resources
    # Install the rust executable where the Python package expects it.
    (venv.site_packages/"hyfetch/rust").install "bin/hyfetch"
  end

  test do
    (testpath/".config/hyfetch.json").write <<~JSON
      {
        "preset": "genderfluid",
        "mode": "rgb",
        "auto_detect_light_dark": true,
        "light_dark": "dark",
        "lightness": 0.5,
        "color_align": {
          "mode": "horizontal",
          "custom_colors": [],
          "fore_back": null
        },
        "backend": "neofetch",
        "args": "--config none --color_blocks off --disable wm de term gpu",
        "distro": null,
        "pride_month_shown": [],
        "pride_month_disable": false
      }
    JSON

    system bin/"neowofetch", "--config", "none", "--color_blocks", "off",
                             "--disable", "wm", "de", "term", "gpu"
    system bin/"hyfetch", "--config-file=#{testpath}/.config/hyfetch.json"
  end
end