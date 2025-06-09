class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https:github.comhangxieparquet-tools"
  url "https:github.comhangxieparquet-toolsarchiverefstagsv1.32.2.tar.gz"
  sha256 "b15f02441ac10ce9b4d962d5db97e28733529cc83f81caa257eb4eebe22ff561"
  license "BSD-3-Clause"
  head "https:github.comhangxieparquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51a0667b3eaa7f4e5c50b51d38813e256561f645d61d1045190c3419c5b83548"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51a0667b3eaa7f4e5c50b51d38813e256561f645d61d1045190c3419c5b83548"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "51a0667b3eaa7f4e5c50b51d38813e256561f645d61d1045190c3419c5b83548"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6040a06e774ab958156e8dd6f15e66b7545d5b641b1602dbfe78fad2c690c68"
    sha256 cellar: :any_skip_relocation, ventura:       "c6040a06e774ab958156e8dd6f15e66b7545d5b641b1602dbfe78fad2c690c68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d24aca10b70d23616be8ff2984eea5e1b3ed36446f1ccf499144b10bf56542fd"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comhangxieparquet-toolscmd.version=v#{version}
      -X github.comhangxieparquet-toolscmd.build=#{time.iso8601}
      -X github.comhangxieparquet-toolscmd.source=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin"parquet-tools")
  end

  test do
    resource("test-parquet") do
      url "https:github.comhangxieparquet-toolsraw950d21759ff3bd398d2432d10243e1bace3502c5testdatagood.parquet"
      sha256 "daf5090fbc5523cf06df8896cf298dd5e53c058457e34766407cb6bff7522ba5"
    end

    resource("test-parquet").stage testpath

    output = shell_output("#{bin}parquet-tools schema #{testpath}good.parquet")
    assert_match "name=parquet_go_root", output
  end
end