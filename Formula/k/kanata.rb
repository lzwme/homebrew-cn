class Kanata < Formula
  desc "Cross-platform software keyboard remapper for Linux, macOS and Windows"
  homepage "https:github.comjtrookanata"
  url "https:github.comjtrookanataarchiverefstagsv1.8.0.tar.gz"
  sha256 "396a379d7620001531b856913a2677baa56fa16c5c9d329f6937dfb57d3ac704"
  license "LGPL-3.0-only"
  head "https:github.comjtrookanata.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00191f3fc71d8c10903c175405b28cf4040814b2f5096e2c610f0c54959d2d98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23b4089f4435096f85e6e88ab7334b55cdd7ab425f7e9793a74e6e1bf23d33fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "592dee4c83f875cb32c43f201e5e02995b495e28d28994eaa9548aea775fe89b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d938a6ac03b75093645f7bbe5caa347133bf916ddc9ff66514caa31601560e72"
    sha256 cellar: :any_skip_relocation, ventura:       "e325b26295ce7c069579b44bc6e429bdaaa14c38345b9e1f6401d3743f4d2747"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2ce466141d3f455c8ea2f09b38cd6bec2e4ce720ff4ca03cd1a78126c50c80c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7ec4ff4482e231762fbdb25f2f9beb751e00a3ccd09f24f6de701200c8cc2e0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath"kanata.kbd").write <<~LISP
      (defsrc
        caps grv         i
                    j    k    l
        lsft rsft
      )

      (deflayer default
        @cap @grv        _
                    _    _    _
        _    _
      )

      (deflayer arrows
        _    _           up
                    left down rght
        _    _
      )

      (defalias
        cap (tap-hold-press 200 200 caps lctl)
        grv (tap-hold-press 200 200 grv (layer-toggle arrows))
      )
    LISP

    system bin"kanata", "--check"
  end
end