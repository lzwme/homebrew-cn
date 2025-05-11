class Xk6 < Formula
  desc "Build k6 with extensions"
  homepage "https:k6.io"
  url "https:github.comgrafanaxk6archiverefstagsv0.19.3.tar.gz"
  sha256 "fccebf5dee0f6a74b8d1d1d2871085fc8c7c0287ca7d12941c8880f440c77bf7"
  license "Apache-2.0"
  head "https:github.comgrafanaxk6.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0da126ae5c448fc6a25b3dbec8f9129fb6a4a406e911c5ea7fdb2b463c0c5357"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0da126ae5c448fc6a25b3dbec8f9129fb6a4a406e911c5ea7fdb2b463c0c5357"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0da126ae5c448fc6a25b3dbec8f9129fb6a4a406e911c5ea7fdb2b463c0c5357"
    sha256 cellar: :any_skip_relocation, sonoma:        "76a469f970cdcd8554fe478843337fc65bd1c229522b4dd5c08e9584a304074f"
    sha256 cellar: :any_skip_relocation, ventura:       "76a469f970cdcd8554fe478843337fc65bd1c229522b4dd5c08e9584a304074f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a308d515bcd1e4f59dd392f705e9cf36dbf8526bad6d3aec0b9e7af56867f46e"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdxk6"
  end

  test do
    str_build = shell_output("#{bin}xk6 build")
    assert_match "xk6 has now produced a new k6 binary", str_build
  end
end