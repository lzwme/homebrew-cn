class C10t < Formula
  desc "Minecraft cartography tool"
  homepage "https:github.comudoprogc10t"
  url "https:github.comudoprogc10tarchiverefstags1.7.tar.gz"
  sha256 "0e5779d517105bfdd14944c849a395e1a8670bedba5bdab281a0165c3eb077dc"
  license "BSD-3-Clause"
  revision 10

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "70ab94023e384a3ab08cfd9e0af0e0a44c83dbca6093465d5723049050243b39"
    sha256 cellar: :any,                 arm64_sonoma:  "95e91b204b1e1a40ffd9a6a2a4bef1fb572612210980e52bc5c6f6eb9d29fe67"
    sha256 cellar: :any,                 arm64_ventura: "7bac068da2879d7f2909fcb2a09d2d5962f1a9be7bed12ec7bb49def6246b83a"
    sha256 cellar: :any,                 sonoma:        "630ca35c4c72f49320d8e11fe2901868b2ad4d82bc247afb875d81e7e8cd1fb7"
    sha256 cellar: :any,                 ventura:       "e81cbae89815db03fc8f84cbdb8a87abc1000eeecbb9ce79ada9e7e968a7b859"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fb0e64ba0f4146416e66bb79fd0972d6ca5af6a6ef087fa519764355f91b14b"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "freetype"
  depends_on "libpng"

  uses_from_macos "zlib"

  # Needed to compile against newer boost
  # Can be removed for the next version of c10t after 1.7
  # See: https:github.comudoprogc10tpull153
  patch do
    url "https:github.comudoprogc10tcommit4a392b9f06d08c70290f4c7591e84ecdbc73d902.patch?full_index=1"
    sha256 "7197435e9384bf93f580fab01097be549c8c8f2c54a96ba4e2ae49a5d260e297"
  end

  # Fix freetype detection; adapted from this upstream commit:
  # https:github.comudoprogc10tcommit2a2b8e49d7ed4e51421cc71463c1c2404adc6ab1
  patch do
    url "https:gist.githubusercontent.commistydemeof7ab02089c43dd557ef4rawa0ae7974e635b8ebfd02e314cfca9aa8dc95029dc10t-freetype.diff"
    sha256 "9fbb7ccc643589ac1d648e105369e63c9220c26d22f7078a1f40b27080d05db4"
  end

  # Ensure zlib header is included for libpng; fixed upstream
  patch do
    url "https:github.comudoprogc10tcommit800977bb23e6b4f9da3ac850ac15dd216ece0cda.patch?full_index=1"
    sha256 "c7a37f866b42ff352bb58720ad6c672cde940e1b8ab79de4b6fa0be968b97b66"
  end

  # Fix build with Boost 1.85.0.
  # Issue ref: https:github.comudoprogc10tissues313
  patch :DATA

  def install
    ENV.cxx11

    args = []
    unless OS.mac?
      args += %W[
        -DCMAKE_LINK_WHAT_YOU_USE=ON
        -DZLIB_LIBRARY=#{Formula["zlib"].opt_lib}libz.so.1
        -DZLIB_INCLUDE_DIR=#{Formula["zlib"].include}
      ]
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "buildc10t"
  end

  test do
    system bin"c10t", "--list-colors"
  end
end

__END__
diff --git asrccache.hpp bsrccache.hpp
index 958b283..f8ddb06 100644
--- asrccache.hpp
+++ bsrccache.hpp
@@ -35,7 +35,7 @@ public:
   cache_file(const fs::path cache_dir, const fs::path source_path, bool cache_compress)
     : cache_dir(cache_dir), source_path(source_path), 
       cache_compress(cache_compress),
-      cache_path(cache_dir  (fs::basename(source_path) + ".cmap"))
+      cache_path(cache_dir  (source_path.stem().string() + ".cmap"))
   {
   }
   
@@ -44,7 +44,7 @@ public:
   }
   
   bool exists() {
-    return fs::is_regular(cache_path)
+    return fs::is_regular_file(cache_path)
       && fs::last_write_time(cache_path) >= fs::last_write_time(source_path);
   }
 
diff --git asrcfileutils.hpp bsrcfileutils.hpp
index 3b8f2a7..45b0cfb 100644
--- asrcfileutils.hpp
+++ bsrcfileutils.hpp
@@ -47,7 +47,7 @@ public:
             ++itr )
       {
         if (fs::is_directory(itr->status())) {
-          if (!filter(fs::basename(itr->path()))) {
+          if (!filter(itr->path().stem().string())) {
             continue;
           }
           
diff --git asrcmain.cpp bsrcmain.cpp
index 78bd49c..5b539bd 100644
--- asrcmain.cpp
+++ bsrcmain.cpp
@@ -1251,7 +1251,7 @@ int main(int argc, char *argv[]){
       
       if (s.use_split) {
         try {
-          boost::format(fs::basename(s.output_path)) % 0 % 0;
+          boost::format(s.output_path.stem().string()) % 0 % 0;
         } catch (boost::io::too_many_args& e) {
           error << "The `-o' parameter must contain two number format specifiers `%d' (x and y coordinates) - example: -o outbase.%d.%d.png";
           goto exit_error;
diff --git asrcmcutils.cpp bsrcmcutils.cpp
index a1b3e0e..2ef6b3e 100644
--- asrcmcutils.cpp
+++ bsrcmcutils.cpp
@@ -83,10 +83,10 @@ namespace mc {
         throw invalid_argument("not a regular file");
       }
       
-      string extension = fs::extension(path);
+      string extension = path.extension().string();
       
       std::vector<string> parts;
-      split(parts, fs::basename(path), '.');
+      split(parts, path.stem().string(), '.');
       
       if (parts.size() != 3 || extension.compare(".dat") != 0) {
         throw invalid_argument("level data file name does not match <x>.<z>.dat");
@@ -104,10 +104,10 @@ namespace mc {
         throw invalid_argument("not a regular file");
       }
       
-      string extension = fs::extension(path);
+      string extension = path.extension().string();
       
       std::vector<string> parts;
-      split(parts, fs::basename(path), '.');
+      split(parts, path.stem().string(), '.');
       
       if (parts.size() != 3 || extension.compare(".mcr") != 0) {
         throw invalid_argument("level data file name does not match <x>.<z>.mcr");
diff --git asrcplayers.cpp bsrcplayers.cpp
index 21b0883..b4afef6 100644
--- asrcplayers.cpp
+++ bsrcplayers.cpp
@@ -32,7 +32,7 @@ void register_double(player *p, std::string name, nbt::Double value) {
 
 player::player(const fs::path path) :
   path(path),
-  name(fs::basename(path)), grammar_error(false), in_pos(false),
+  name(path.stem().string()), grammar_error(false), in_pos(false),
   pos_c(0), xPos(0), yPos(0), zPos(0)
 {
   nbt::Parser<player> parser(this);