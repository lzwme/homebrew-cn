class Sdns < Formula
  desc "Privacy important, fast, recursive dns resolver server with dnssec support"
  homepage "https:sdns.dev"
  url "https:github.comsemihalevsdnsarchiverefstagsv1.5.0.tar.gz"
  sha256 "948320bcd562f696efc38a7ec30897a36c27e31aeedff6fd227bd853fdf537ba"
  license "MIT"
  head "https:github.comsemihalevsdns.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38aad4fa349df341c5c4e4581477e3a61bd434ac7d5ba9b1ae1dd6b7044f0a16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8eb0a65049db30a3103b164d8edcd4318bb0a313d488811b2f17b40f0ec598b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f9698f413aa1ca5a0cb73b59a35aaa51a7c66b437eba54a1b06b7a0eea393717"
    sha256 cellar: :any_skip_relocation, sonoma:        "c867295b6b18f2e6749ed520d63278c91110ff149d8e2b5d50e42a936f0c87d0"
    sha256 cellar: :any_skip_relocation, ventura:       "baa96e646837d2a71d31f6ae6913f03049577177df6db7cde30d56daa4084e8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1bcbe2cb1d1a519b773034dce27d5085d4852fae8f36e2b494c773c24e23f152"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f225e6eaeafd37bf6c7fec3d48bc694ea55b2597da9d4ecc03ba179337a405c5"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "sdns"
  end

  service do
    run [opt_bin"sdns", "--config", etc"sdns.conf"]
    keep_alive true
    require_root true
    error_log_path var"logsdns.log"
    log_path var"logsdns.log"
    working_dir opt_prefix
  end

  test do
    spawn bin"sdns", "--config", testpath"sdns.conf"
    sleep 2
    assert_path_exists testpath"sdns.conf"
  end
end