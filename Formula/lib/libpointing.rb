class Libpointing < Formula
  desc "Provides direct access to HID pointing devices"
  homepage "https:github.comINRIAlibpointing"
  url "https:github.comINRIAlibpointingreleasesdownloadv1.0.8libpointing-mac-1.0.8.tar.gz"
  sha256 "b19a701b9181be05c3879bbfc901709055c27de7995bd59ada4e3f631dfad8f2"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_sequoia:  "fc963b2d475b92c4a7fd7a525d0ae301cedad7c825d50bd47f1e174be955ab51"
    sha256 cellar: :any, arm64_sonoma:   "2d7abf099808b966f2e79ff4ee050ae9ba2dcaa009577575a8ceceeb657e3cda"
    sha256 cellar: :any, arm64_ventura:  "79773a252a784d765237674545e3355bec847c95f9ac82cc89826936954f8990"
    sha256 cellar: :any, arm64_monterey: "777a0f897878a4da3693f9d8a5717f42ff70fc281a81b57b4841a31ce17e7100"
    sha256 cellar: :any, arm64_big_sur:  "19de172dd9ad6744f9939955a5c526d3626400727631cdd07a6e22d8791fbf48"
    sha256 cellar: :any, sonoma:         "ca321e413ebc04effeb4c54ee765a9954eccfed31df4111413480826429ca5d2"
    sha256 cellar: :any, ventura:        "97732d46ffab874e21adbaeaf3a6953df026772565ccfa5dcb5f5d51378ac75e"
    sha256 cellar: :any, monterey:       "9fad8e2c767cc76679b49546cf443a0ec1d7b7115dbd82faaff20649b3b77ff4"
    sha256 cellar: :any, big_sur:        "e9168eee924fc759e012e3ef41d64750d732f0d09a7af068fd935746835da472"
    sha256 cellar: :any, catalina:       "d56d66f5df0d6e1c80cc4e4951e8add9cbb0c5fb76080c9107f66665b8b46e48"
    sha256 cellar: :any, mojave:         "adecdbec3a556dfd78dd1aa24f6868814fc4b3243310311192fee4e9de912c62"
    sha256 cellar: :any, high_sierra:    "97e7550c8e3c3007df96cc98eab35a297ed857a6fd1bc24011d1dea8350966e5"
    sha256 cellar: :any, sierra:         "1fc9b4bdab762eb8f93c4a75c57e82b14f3274186f5185fa9a17e8d0f3bc3452"
  end

  def install
    ENV.cxx11
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath"test.cpp").write <<~EOS
      #include <pointingpointing.h>
      #include <iostream>
      int main() {
        std::cout << LIBPOINTING_VER_STRING << " |" ;
        std::list<std::string> schemes = pointing::TransferFunction::schemes() ;
        for (std::list<std::string>::iterator i=schemes.begin(); i!=schemes.end(); ++i) {
          std::cout << " " << (*i) ;
        }
        std::cout << std::endl ;
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-lpointing", "-o", "test"
    system ".test"
  end
end