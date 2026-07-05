class Znapzend < Formula
  desc "ZFS backup with remote capabilities and mbuffer integration"
  homepage "https://www.znapzend.org/"
  url "https://ghfast.top/https://github.com/oetiker/znapzend/releases/download/v0.23.4/znapzend-0.23.4.tar.gz"
  sha256 "253a2719c119d59a7e6db3f4aa26bc9b3b4fd74c2e737b9c8726cdb670abc6fc"
  license "GPL-3.0-or-later"
  head "https://github.com/oetiker/znapzend.git", branch: "master"

  # The `stable` URL uses a download from the GitHub release, so the release
  # needs to exist before the formula can be version bumped. It's more
  # appropriate to check the GitHub releases instead of tags in this context.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f8378d692733374a38059e3071b55965c1adcf84c73b95d6739dcff697861d3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0f8093937848fe55f65758124f64a9bc5171d38bb93fe7513f2125d239686d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09cd752296568e72d73432cbd72dfc6f8322dc3f2d85c428ed0fc5feb0d8b597"
    sha256 cellar: :any_skip_relocation, sonoma:        "61567a0bebca841d728d86da73528130cb1a7557fb4b52f1df84a7dc528a52ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7add210a1fac6e733530c411c4b2cb7569b7181e6b170a8f921e28dd98556ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b0dce8bc457338ddf7dcd4d28e7b3b6125c99c8c0af3daeb67da85563a1ba6d"
  end

  uses_from_macos "perl", since: :big_sur

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
    (var/"log/znapzend").mkpath
  end

  service do
    run [opt_bin/"znapzend", "--connectTimeout=120", "--logto=#{var}/log/znapzend/znapzend.log"]
    environment_variables PATH: std_service_path_env
    keep_alive true
    require_root true
    error_log_path var/"log/znapzend.err.log"
    log_path var/"log/znapzend.out.log"
    working_dir var/"run/znapzend"
  end

  test do
    fake_zfs = testpath/"zfs"
    fake_zfs.write <<~SH
      #!/bin/sh
      for word in "$@"; do echo $word; done >> znapzendzetup_said.txt
      exit 0
    SH
    chmod 0755, fake_zfs
    ENV.prepend_path "PATH", testpath

    system bin/"znapzendzetup", "list"

    assert_equal <<~EOS, (testpath/"znapzendzetup_said.txt").read
      list
      -H
      -o
      name
      -t
      filesystem,volume
    EOS
  end
end