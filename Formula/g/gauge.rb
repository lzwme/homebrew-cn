class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https:gauge.org"
  url "https:github.comgetgaugegaugearchiverefstagsv1.6.0.tar.gz"
  sha256 "da94454ac0a0e338533802419b632bece73be70194a548cd19fe6f6a3fca28fc"
  license "Apache-2.0"
  head "https:github.comgetgaugegauge.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b8a4958cd18fcba70963f1da8a698a777847e02d4aed818e4bcd33c06469bb0d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "72682d4a5ef1b5de3ba9d43e63e54ec0bfb39f0b7dc3dd75ed4e618b96ed6883"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce63cbde737a9a5002058c56f584dea83f2fe7607fe2059d5fd9b5cb1a52e0d6"
    sha256 cellar: :any_skip_relocation, sonoma:         "0a35c695f537284c9870af0bedfd55be5b118c3a56fe15787e80c89e2a013796"
    sha256 cellar: :any_skip_relocation, ventura:        "c5d2a6703e4fc4db275e6078ecfb878012f78204e13a1ece29fedc96e931487e"
    sha256 cellar: :any_skip_relocation, monterey:       "b6ab79d337c4f32d5cf56e969b42122f162e2f8e92a907d50cd39cba25e664e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca08913353c4766618c6e5865909bd9fe91fc518b000665d75800056e9a5060c"
  end

  depends_on "go" => :build

  def install
    system "go", "run", "buildmake.go"
    system "go", "run", "buildmake.go", "--install", "--prefix", prefix
  end

  test do
    (testpath"manifest.json").write <<~EOS
      {
        "Plugins": [
          "html-report"
        ]
      }
    EOS

    system("#{bin}gauge", "install")
    assert_predicate testpath".gaugeplugins", :exist?

    system("#{bin}gauge", "config", "check_updates", "false")
    assert_match "false", shell_output("#{bin}gauge config check_updates")

    assert_match version.to_s, shell_output("#{bin}gauge -v 2>&1")
  end
end