class Vapor < Formula
  desc "Command-line tool for Vapor (Server-side Swift web framework)"
  homepage "https:vapor.codes"
  url "https:github.comvaportoolboxarchiverefstags19.2.0.tar.gz"
  sha256 "c2970459166469afe8614ecdca33dae556a5e2fb386b92eeba2498af9014fc60"
  license "MIT"
  head "https:github.comvaportoolbox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f2c6943fa3c7ce08edf4fe755bc457fd5182b5cbefbb8d72c529c9c725b7a29"
    sha256 cellar: :any,                 arm64_sonoma:  "e4eb5458e494f81f695d6be97343d49befba175e46d1408f2d97d39ad60a9e3e"
    sha256 cellar: :any,                 arm64_ventura: "485828ab22141232f3b316fe8bb6d71140de71ef521de4854a1500b922ba093b"
    sha256 cellar: :any,                 sonoma:        "286cab5c6174a01ace08ae6c190aff18d484b7466ea718164bea75ced45540db"
    sha256 cellar: :any,                 ventura:       "140bed5e1eb6392a50317549580f1ed06031cc684c32337cc28e668e92d71e89"
    sha256                               arm64_linux:   "3c7444e3bc22eda208626e10ebf482b669a7fe043cd83912ed9227e4e8b5a681"
    sha256                               x86_64_linux:  "68d00588ea3a03d785c0e2fd0745d3310136cd5f366de20a9b2db8142d0be06b"
  end

  uses_from_macos "swift", since: :sequoia # Swift 6.0

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "-c", "release", "-Xswiftc", "-cross-module-optimization"
    bin.install ".buildreleasevapor"
  end

  test do
    system bin"vapor", "new", "hello-world", "-n"
    assert_path_exists testpath"hello-worldPackage.swift"
  end
end