class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://ghfast.top/https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.38.3.tar.gz"
  sha256 "771edca4196c04381e53ee817dbfc85468856d39610b59fb58db3b489fe19dce"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17e931a4965e2ff7ba64b058b6adc351754a8fce067b0357dbcf9e2ccccacaaf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17e931a4965e2ff7ba64b058b6adc351754a8fce067b0357dbcf9e2ccccacaaf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17e931a4965e2ff7ba64b058b6adc351754a8fce067b0357dbcf9e2ccccacaaf"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3c00fe338952cb2adfa5dd9fb43487a1dea873f22871b502cee9385d813e32b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a228e09278c230aa0f4c3f8ea971ff6747a1d6746d02e2d165d5f8aa879bc5f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e4ea2632b2aad337f2cecb3dd9220365968d73050f16abaa7840d93a8871b20"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/hangxie/parquet-tools/cmd.version=v#{version}
      -X github.com/hangxie/parquet-tools/cmd.build=#{time.iso8601}
      -X github.com/hangxie/parquet-tools/cmd.source=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"parquet-tools")
  end

  test do
    resource("test-parquet") do
      url "https://github.com/hangxie/parquet-tools/raw/950d21759ff3bd398d2432d10243e1bace3502c5/testdata/good.parquet"
      sha256 "daf5090fbc5523cf06df8896cf298dd5e53c058457e34766407cb6bff7522ba5"
    end

    resource("test-parquet").stage testpath

    output = shell_output("#{bin}/parquet-tools schema #{testpath}/good.parquet")
    assert_match "name=parquet_go_root", output
  end
end