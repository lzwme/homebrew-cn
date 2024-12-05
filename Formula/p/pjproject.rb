class Pjproject < Formula
  desc "C library for multimedia protocols such as SIP, SDP, RTP and more"
  homepage "https:www.pjsip.org"
  url "https:github.compjsippjprojectarchiverefstags2.15.tar.gz"
  sha256 "b744544e5028d09d8c2f774d135e0f543930028c04580faa00590b78ee335973"
  license "GPL-2.0-or-later"
  head "https:github.compjsippjproject.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3bce3cff2ec13273007ae8450013aaf0275e0a91090ae115b5d454df748ab34e"
    sha256 cellar: :any,                 arm64_sonoma:  "949a07456796e03346d08eaf80532eec94704da1202c7110c09bbfb88d7805cd"
    sha256 cellar: :any,                 arm64_ventura: "453a0ae03386fc190c2d9abd4cafdb1447f6f23def1bad31374906ca3fc9bf80"
    sha256 cellar: :any,                 sonoma:        "dd95589339500773c7c5b2e79e9933c414c7e9f2c059709720254d4a4a0e5030"
    sha256 cellar: :any,                 ventura:       "f7520b91b018533540ec78193fcf512e542a5fb933debb2867a56cf579359bc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e67f8780a0644f65e4254c99fbf75075d631bcb99988cc936fa60a4601a3f0eb"
  end

  depends_on macos: :high_sierra # Uses Security framework API enum cases introduced in 10.13.4
  depends_on "openssl@3"

  def install
    system ".configure", "--prefix=#{prefix}"
    ENV.deparallelize
    system "make", "dep"
    system "make"
    system "make", "install"

    arch = (OS.mac? && Hardware::CPU.arm?) ? "arm" : Hardware::CPU.arch.to_s
    target = OS.mac? ? "apple-darwin#{OS.kernel_version}" : "unknown-linux-gnu"

    bin.install "pjsip-appsbinpjsua-#{arch}-#{target}" => "pjsua"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}pjsua --version 2>&1")
  end
end