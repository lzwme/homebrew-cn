class Pdfcpu < Formula
  desc "PDF processor written in Go"
  homepage "https://pdfcpu.io"
  url "https://ghfast.top/https://github.com/pdfcpu/pdfcpu/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "9e824957d847af70585e9b5c94070e3b78377c876adadc0b90e37afcf706ba69"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f0435b9dff946e24f78fcb103a1596bef088c2bb9ba67996b5ec881897e83c15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0435b9dff946e24f78fcb103a1596bef088c2bb9ba67996b5ec881897e83c15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0435b9dff946e24f78fcb103a1596bef088c2bb9ba67996b5ec881897e83c15"
    sha256 cellar: :any_skip_relocation, sonoma:        "22480c05ea1e8e32501e1b031684a50638743c30302ff0b37fb54b43e61f4ad7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "023ae1a5cd43a63a88817f1fdb38e7d53f5d082e7c083e7b44e14cd375f97d97"
    sha256 cellar: :any,                 x86_64_linux:  "d64334c76e49e522305f9320042459ffcfb736666f3da46be53f3b1166ea23b5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X github.com/pdfcpu/pdfcpu/pkg/pdfcpu.VersionStr=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/pdfcpu"
  end

  test do
    config_file = if OS.mac?
      testpath/"Library/Application Support/pdfcpu/config.yml"
    else
      testpath/".config/pdfcpu/config.yml"
    end
    # basic config.yml
    config_file.write <<~YAML
      reader15: true
      validationMode: ValidationRelaxed
      eol: EolLF
      encryptKeyLength: 256
      unit: points
    YAML

    assert_match version.to_s, shell_output("#{bin}/pdfcpu version")

    info_output = shell_output("#{bin}/pdfcpu info #{test_fixtures("test.pdf")}")
    assert_match <<~EOS, info_output
      #{test_fixtures("test.pdf")}:
                    Source: #{test_fixtures("test.pdf")}
               PDF version: 1.6
                Page count: 1
                Page sizes: 500.00 x 800.00 points
    EOS

    assert_match "validation ok", shell_output("#{bin}/pdfcpu validate #{test_fixtures("test.pdf")} 2>&1")
  end
end