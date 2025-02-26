class Chkbit < Formula
  desc "Check your files for data corruption"
  homepage "https:github.comlaktakchkbit"
  url "https:github.comlaktakchkbitarchiverefstagsv6.2.0.tar.gz"
  sha256 "faaf2d26d44a5a74855c40aabe07d6a41030c3fdfe1181993290ed04e9f62bb9"
  license "MIT"
  head "https:github.comlaktakchkbit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58e8e69d9610b0742ec35814b7ac92bb381db23aefc895e0821a1031494952f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58e8e69d9610b0742ec35814b7ac92bb381db23aefc895e0821a1031494952f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "58e8e69d9610b0742ec35814b7ac92bb381db23aefc895e0821a1031494952f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b402adc9887d56427bbf671726cf64d49891c206ab817c8373e1bd50c0a2753"
    sha256 cellar: :any_skip_relocation, ventura:       "2b402adc9887d56427bbf671726cf64d49891c206ab817c8373e1bd50c0a2753"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d94fe5b41c65242f1f7e97aa6ef720f65d308bba135728b8e22a489eff59103d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.appVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdchkbit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}chkbit version").chomp
    system bin"chkbit", "init", "split", testpath
    assert_path_exists testpath".chkbit"
  end
end