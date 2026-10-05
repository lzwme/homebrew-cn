class Pdfcpu < Formula
  desc "PDF processor written in Go"
  homepage "https://pdfcpu.io"
  url "https://ghfast.top/https://github.com/pdfcpu/pdfcpu/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "bee48520012b0997b2de61114d3af6ea4d8a1d5fc8d98443de5ff231664155aa"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "661ae04e39de6771c56e2945559324c9d4cbd1836a88a6091c148b5fd26b68c3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "661ae04e39de6771c56e2945559324c9d4cbd1836a88a6091c148b5fd26b68c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "661ae04e39de6771c56e2945559324c9d4cbd1836a88a6091c148b5fd26b68c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bbfbef906d72b338a348dfba6e177933f5bfeed37e964f3cdc5358cb4b9d8f6c"
    sha256 cellar: :any,                 x86_64_linux:      "3a056ea29ca66f2e9471262af87333ac004292f55e01d7b3cf957c6042539831"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
      schemaVersion: 1
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