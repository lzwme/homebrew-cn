class Oslo < Formula
  desc "CLI tool for the OpenSLO spec"
  homepage "https:openslo.com"
  url "https:github.comOpenSLOosloarchiverefstagsv0.13.0.tar.gz"
  sha256 "8e3c501103cbfb0d9980a6ea023def0bdef2fe111a8aec3b106302669d452ec2"
  license "Apache-2.0"
  head "https:github.comopenslooslo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1dc252e4e8d683047409636266e7c11e62725cc9ac3a21c394c1a0f04b644654"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1dc252e4e8d683047409636266e7c11e62725cc9ac3a21c394c1a0f04b644654"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1dc252e4e8d683047409636266e7c11e62725cc9ac3a21c394c1a0f04b644654"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd87cd615862dce34c7e3372d0b2496cb34a4813a352fa0e9c677eaaaa2cbf95"
    sha256 cellar: :any_skip_relocation, ventura:       "bd87cd615862dce34c7e3372d0b2496cb34a4813a352fa0e9c677eaaaa2cbf95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ab3bfa70149e279e8a2902afe6ff19044c128da80df54b70fd711ed3ac445be"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdoslo"

    generate_completions_from_executable(bin"oslo", "completion")

    pkgshare.install "test"
  end

  test do
    test_file = pkgshare"testinputsvalidateunknown-field.yaml"
    assert_match "json: unknown field", shell_output("#{bin}oslo validate -f #{test_file} 2>&1", 1)

    output = shell_output("#{bin}oslo fmt -f #{pkgshare}testinputsfmtservice.yaml")
    assert_equal File.read(pkgshare"testoutputsfmtservice.yaml"), output
  end
end