class Hyfetch < Formula
  include Language::Python::Virtualenv

  desc "Fast, highly customisable system info script with LGBTQ+ pride flags"
  homepage "https://github.com/hykilpikonna/hyfetch"
  url "https://files.pythonhosted.org/packages/71/ac/16335a530041683e3c193694cc9db3b53ebfed9dab3db3b69d485bda8ce4/hyfetch-2.0.1.tar.gz"
  sha256 "bec29bfa0bc2b7309782348a0ca7c906cb481a3375da04b3c7f58a6f5cb512f9"
  license "MIT"
  head "https://github.com/hykilpikonna/hyfetch.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31e680df65150d190705ba61e3f068406ad45043f492fb0ad8f63f060ef59611"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9373613ddfb2d360b59abf4268cc1f45e3e8f19e14486233012e5773eaa0d295"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fb47891108172c2c4723689fe04fbdb3f14a8f1968acf60cb3eb366909953746"
    sha256 cellar: :any_skip_relocation, sonoma:        "b798a9c96bb06c5890829acb1cff48c198dbbdb657faf51671d3a80f17e4683e"
    sha256 cellar: :any_skip_relocation, ventura:       "f84d32b7145350501aca7441085454ca8c822c05fb6b5d543f8a72e7ceb72a3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22f601bb4312ad5afda10047c666dfcf1b1baa211cc1dc05a2a5313dc70ce380"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34eaa8055a0f8078a95c910ac407fc2a840c3be5a6f72c4e6250275407ad54ea"
  end

  depends_on "rust" => :build
  depends_on "python@3.13"

  def install
    # Install to `buildpath` first or else `virtualenv_install_with_resources` will overwrite it.
    system "cargo", "install", *std_cargo_args(path: "crates/hyfetch", root: buildpath)
    virtualenv_install_with_resources
    # Install the rust executable where the Python package expects it.
    (libexec/Language::Python.site_packages("python3")/"hyfetch/rust").install "bin/hyfetch"
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