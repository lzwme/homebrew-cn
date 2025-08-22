class Hyfetch < Formula
  include Language::Python::Virtualenv

  desc "Fast, highly customisable system info script with LGBTQ+ pride flags"
  homepage "https://github.com/hykilpikonna/hyfetch"
  url "https://files.pythonhosted.org/packages/71/ac/16335a530041683e3c193694cc9db3b53ebfed9dab3db3b69d485bda8ce4/hyfetch-2.0.1.tar.gz"
  sha256 "bec29bfa0bc2b7309782348a0ca7c906cb481a3375da04b3c7f58a6f5cb512f9"
  license "MIT"
  head "https://github.com/hykilpikonna/hyfetch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "55446c64fe707ad34df6df6193ccaac2e599597bf6e340a8753881a22f431867"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/".config/hyfetch.json").write <<~JSON
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
    JSON

    system bin/"neowofetch", "--config", "none", "--color_blocks", "off",
                             "--disable", "wm", "de", "term", "gpu"
    system bin/"hyfetch", "-C", testpath/"hyfetch.json",
                          "--args=\"--config none --color_blocks off --disable wm de term gpu\""
  end
end